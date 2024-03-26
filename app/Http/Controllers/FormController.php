<?php

namespace App\Http\Controllers;

use App\Models\Form;
use App\Models\Sector;
use App\Rules\ExistsInDatabase;
use App\Services\FormService;
use Exception;
use Illuminate\Contracts\View\Factory;
use Illuminate\Contracts\View\View;
use Illuminate\Foundation\Application;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Redirect;

class FormController extends Controller
{
    public function __construct(
        protected FormService $formService,
        protected ExistsInDatabase $existsInDatabase
    ) {}

    /**
     * @return \Illuminate\Contracts\Foundation\Application|Factory|View|Application
     */
    public function index(): Application|View|Factory|\Illuminate\Contracts\Foundation\Application
    {
        return view('form', [
            'form' => new Form(),
            'sectorIds' => [],
            'sectors' => Sector::tree()->get()->toTree()
        ]);
    }

    /**
     * @param string $uuid
     * @return \Illuminate\Contracts\Foundation\Application|Factory|View|Application|RedirectResponse
     */
    public function getForm(string $uuid): RedirectResponse|\Illuminate\Contracts\Foundation\Application|Factory|View|Application
    {
        $form = Form::where('uuid', $uuid)->with('sectors')->first();

        if (!$form) {
            return Redirect::to('/')->with('error', 'Not found');
        }

        $sectorIds = $form->sectors->pluck('id')->toArray();
        $sectors = Sector::tree()->get()->toTree();

        return view('form', [
            'form' => $form,
            'sectors' => $sectors,
            'sectorIds' => $sectorIds
        ]);
    }

    /**
     * @param Request $request
     * @return RedirectResponse
     */
    public function save(Request $request): RedirectResponse
    {
        request()->validate([
            'sectors' => ['required', $this->existsInDatabase],
            'name' => 'required',
            'terms' => 'accepted'
        ]);

        try {
            $form = $this->formService->saveForm([
                'sectors' => $request->get('sectors'),
                'name' => $request->get('name'),
                'terms' => $request->get('terms')
            ]);
        } catch (Exception $e) {
            return Redirect::back()->with('error', 'Failed to save the form.');
        }

        return Redirect::to('/forms/'.$form->uuid)->with('success', 'Form saved!');
    }

    /**
     * @param Request $request
     * @param $uuid
     * @return RedirectResponse
     */
    public function update(Request $request, $uuid): RedirectResponse
    {
        request()->validate([
            'sectors' => ['required', $this->existsInDatabase],
            'name' => 'required',
            'terms' => 'accepted'
        ]);

        $form = Form::where('uuid', $uuid)->first();

        if (!$form) {
            return Redirect::back()->with('error', 'Not found');
        }

        try {
            $this->formService->updateForm($form ,[
                'sectors' => $request->get('sectors'),
                'name' => $request->get('name'),
                'terms' => $request->get('terms')
            ]);
        } catch (Exception $e) {
            return Redirect::back()->with('error', 'Failed to update the form');
        }

        return Redirect::back()->with('success', 'Form updated successfully');
    }
}
