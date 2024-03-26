<?php

namespace App\Rules;

use Closure;
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Support\Facades\DB;
use Illuminate\Translation\PotentiallyTranslatedString;

class ExistsInDatabase implements ValidationRule
{

    protected string $table;
    protected string $column;

    public function __construct($table, $column)
    {
        $this->table = $table;
        $this->column = $column;
    }

    /**
     * Run the validation rule.
     *
     * @param string $attribute
     * @param mixed $value
     * @param Closure(string): PotentiallyTranslatedString $fail
     */
    public function validate(string $attribute, mixed $value, Closure $fail): void
    {
        if (DB::table($this->table)->whereIn($this->column, $value)->count() !== count($value)) {
            $fail('One or more IDs do not exist in the database.');
        }
    }
}
