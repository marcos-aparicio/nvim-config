cd "$(dirname "$0")"
if [ ! -f "./lua/globals.lua" ]; then
  cp "./lua/globals.example.lua" "./lua/globals.lua"
fi

