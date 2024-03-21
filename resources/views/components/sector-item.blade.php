@props(['sector', 'sectorIds' ,'indentation' => 0])

@php
    $padding = 20 * $indentation . 'px';
@endphp

@if ($sector->isOptgroup())
    <optgroup label="{{ $sector->name }}" style="padding-left: {{ $padding }}">
        @foreach($sector->children as $child)
            <x-sector-item :sector='$child' :sectorIds="$sectorIds" :indentation='$indentation + 1' />
        @endforeach
    </optgroup>
@endif
@if ($sector->isOption())
    <option value="{{ $sector->id }}" {{ in_array($sector->id, old('sectors', $sectorIds)) ? 'selected' : '' }}>{{ $sector->name }}</option>
@endif
