<?php

namespace App\Services;

use App\Models\Sector;
use DOMDocument;
use DOMElement;

class ParsingService
{
    public function parseAndInsertHtml($html): void
    {
        $dom = new DOMDocument();
        $dom->loadHTML($html);

        $select = $dom->getElementsByTagName('select')->item(0);
        $this->parseAndInsertOptgroupsRecursive($select->childNodes);
    }

    protected function parseAndInsertOptgroupsRecursive($nodes, $parentId = null): void
    {
        foreach ($nodes as $node) {
            if ($node instanceof DOMElement) {
                if ($node->nodeName === 'optgroup') {
                    $label = $node->getAttribute('label');
                    $optGroup = $this->insertSector($label, $parentId, 'optgroup');

                    $this->parseAndInsertOptgroupsRecursive($node->childNodes, $optGroup->id);
                }

                if ($node->nodeName === 'option') {
                    $label = $node->textContent;
                    $this->insertSector($label, $parentId);
                }
            }
        }
    }

    protected function insertSector($label, $parentId = null, $type = 'option'): Sector
    {
        $existingSector = Sector::where('name', $label)
            ->where('parent_id', $parentId)
            ->first();

        if ($existingSector) {
            return $existingSector;
        }

        $sector = new Sector([
            'name' => $label,
            'parent_id' => $parentId,
            'type' => $type
        ]);
        $sector->save();

        return $sector;
    }

}
