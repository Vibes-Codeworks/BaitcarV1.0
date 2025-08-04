# BaitcarV1.0
Simple bait car script for Five m [standalone]

Bait Car Script (FiveM)
This is my first publicly released script for FiveM. It’s a simple but functional bait car system designed for RP servers, allowing players or police to remotely disable and control a marked vehicle.

📦 Features
/baitcar — Marks your current vehicle as a bait car.

/baitmenu [netId] — Opens the bait car control menu for the specified vehicle.

Simple and responsive NUI menu.

Uses native functions to disable the engine and lock/unlock the vehicle.

Easily extendable with item triggers or external control logic.

🔧 How It Works
Enter the vehicle you want to set as a bait car.

Use /baitcar to mark it.

The net ID of the vehicle will be displayed in the chat.

Use /baitmenu [netId] to open the remote control interface for that specific vehicle.

Example:
/baitmenu 42

✅ To-Do / Planned Upgrades
Add plug and play feture for qbcore compatability such as job checks and usable items

UI polish (icon buttons, animations).

Add dashcam to show inside car.

Add auto trigger feture to toggle the door locks such when someone get in the car thats not a cop.

🛠️ Setup
Drop the folder into your resources directory.

Ensure the resource in your server.cfg:
ensure baitcar
Done!

💬 Feedback
This is my first published script, so I’m open to feedback, suggestions, or PRs. If you have fixes, optimizations, or ideas for expansion, feel free to submit a pull request or open an issue.

Thanks for checking it out!
