<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Form extends Model
{
    use HasFactory;

    protected $fillable = ['name', 'agreed'];

    public function sectors(): BelongsToMany
    {
        return $this->belongsToMany(Sector::class, 'form_sector');
    }
}
