<?php

namespace App\Services;

use App\Models\Form;
use Exception;
use Illuminate\Support\Facades\Log;

class FormService
{

    /**
     * @param array $array
     * @return mixed
     * @throws Exception
     */
    public function saveForm(array $array): Form
    {
        try {
            $sectors = $array['sectors'];
            $form = Form::create([
                'name' => $array['name'],
                'agreed' => $array['terms'] === 'on' ? 1 : 0
            ]);
            foreach ($sectors as $sector) {
                $form->sectors()->attach($sector);
            }

            // get uuid
            $form->refresh();
        } catch (Exception $e) {
            Log::error('Failed to save form correctly', [
                'message' => $e->getMessage()
            ]);
            throw new Exception('Failed to save form correctly');
        }

        return $form;
    }

    /**
     * @param Form $form
     * @param array $array
     * @return void
     * @throws Exception
     */
    public function updateForm(Form $form, array $array): void
    {
        try {
            $form->name = $array['name'];
            $form->agreed = $array['terms'] === 'on' ? 1 : 0;
            $form->sectors()->sync($array['sectors']);
            $form->save();
        } catch (Exception $e) {
            Log::error('Failed to update form', [
                'message' => $e->getMessage()
            ]);
            throw new Exception('Failed to update the form');
        }
    }
}
