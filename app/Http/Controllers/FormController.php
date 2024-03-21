<?php

namespace App\Http\Controllers;

use App\Models\Form;
use App\Models\Sector;
use App\Services\FormService;
use Exception;
use Illuminate\Contracts\View\Factory;
use Illuminate\Contracts\View\View;
use Illuminate\Foundation\Application;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Redirect;

class FormController extends Controller
{
    public function __construct(
        protected FormService $formService
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
     * @return \Illuminate\Contracts\Foundation\Application|Factory|View|Application|JsonResponse
     */
    public function getForm(string $uuid): Application|View|Factory|JsonResponse|\Illuminate\Contracts\Foundation\Application
    {
        $form = Form::where('uuid', $uuid)->with('sectors')->first();

        if (!$form) {
            return response()->json("Not found", 404);
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
     * @return JsonResponse
     */
    public function save(Request $request): JsonResponse
    {
        request()->validate([
            'sectors' => 'required',
            'name' => 'required',
            'terms' => 'accepted'
        ]);

        try {
            $this->formService->saveForm([
                'sectors' => $request->get('sectors'),
                'name' => $request->get('name'),
                'terms' => $request->get('terms')
            ]);
        } catch (Exception $e) {
            return response()->json('Failed to save the form.');
        }

        return response()->json("New form saved!");
    }

    /**
     * @param Request $request
     * @param $uuid
     * @return JsonResponse|RedirectResponse
     */
    public function update(Request $request, $uuid): JsonResponse|RedirectResponse
    {
        request()->validate([
            'sectors' => 'required',
            'name' => 'required',
            'terms' => 'accepted'
        ]);

        $form = Form::where('uuid', $uuid)->first();

        if (!$form) {
            return response()->json("Not found", 404);
        }

        try {
            $this->formService->updateForm($form ,[
                'sectors' => $request->get('sectors'),
                'name' => $request->get('name'),
                'terms' => $request->get('terms')
            ]);
        } catch (Exception $e) {
            return response()->json('Failed to update the form.');
        }

        return Redirect::back()->with('success', 'Form updated successfully');
    }
}
