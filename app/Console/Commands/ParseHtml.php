<?php

namespace App\Console\Commands;

use App\Services\ParsingService;
use Illuminate\Console\Command;

class ParseHtml extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'html:parse {file}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Parse HTML file select options to the DB';

    protected $parsingService;

    public function __construct(ParsingService $parsingService) {
        parent::__construct();
        $this->parsingService = $parsingService;
    }

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $file = $this->argument('file');

        if (!file_exists($file)) {
            $this->error('File does not exist.');
            return;
        }

        $html = file_get_contents($file);
        $this->parsingService->parseAndInsertHtml($html);
    }
}
