<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Staudenmeir\LaravelAdjacencyList\Eloquent\HasRecursiveRelationships;

class Sector extends Model
{
    use HasFactory;

    protected $fillable = ['name', 'parent_id'];

    use HasRecursiveRelationships;

    public function forms(): BelongsToMany
    {
        return $this->belongsToMany(Form::class, 'form_sector');
    }

    public function isOptgroup(): bool
    {
        return $this->children()->exists();
    }

    public function isOption(): bool
    {
        return !$this->isOptgroup();
    }
}
