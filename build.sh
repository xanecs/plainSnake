#!/bin/bash

rm game.love
cd src
zip -9 -r game.love .
cd ..
mv src/game.love .
