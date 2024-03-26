<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Form</title>
    </head>
    <body>
    @if($form->uuid)
        <form action="{{ route('updateForm', ['uuid' => $form->uuid]) }}" method="POST">
    @else
        <form action="{{ route('saveForm') }}" method="POST">
    @endif
            @csrf
            <h2>Please enter your name and pick the Sectors you are currently involved in.</h2>
            @if (session('success'))
                <div>{{ session('success') }}</div>
            @endif
            @if (session('error'))
                <div>{{ session('error') }}</div>
            @endif
            <div>
                <label for="name">
                    <div>Name</div>
                    @error("name")
                        <div class="text-danger">{{ $message }}</div>
                    @enderror
                    <input type="text" name="name" value="{{ old('name', $form->name) }}">
                </label>
            </div>
            <div>
            </div>
            <div>
                <label for="sectors">
                    <div>Sectors</div>
                    @error("sectors")
                        <div class="text-danger">{{ $message }}</div>
                    @enderror
                    <select multiple name="sectors[]" size="50">
                        @foreach($sectors as $sector)
                            <x-sector-item :sector="$sector" :sectorIds="$sectorIds" />
                        @endforeach
                    </select>
                </label>
            </div>
            <br />
            <br />
            <label for="terms">Agree to terms
                @error("terms")
                    <div class="text-danger">{{ $message }}</div>
                @enderror
                <input type="checkbox" name="terms" {{ $form->agreed ? 'checked' : ''}}>
            </label>
            <br />
            <br />
            <input type="submit" value="Save">
        </form>
    </body>
</html>
