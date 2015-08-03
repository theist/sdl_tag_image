# Ruby Quick Tagger #

This program was for because a needed a way to visually tag mame snapshots. Is a rubygame script, needs SDL and stuff like that.

## Preconfiguration ##

It needs a image list called `imagelist.txt` and a categories `categories.txt` each category will be mapped to the keys 1-9

## Usage ##

Choose between 0-9 to categorize the big image in to the mapped category, next images are shown at the right edge. The categorisation is stored in `clasification.txt` in pairs `image path = category`

If you want to end th taggging session you can it 'q' key and the remaining image paths will be stored in `imagelist.txt`
