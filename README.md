# Dev Decompiler (Executor Version)

**Dev Decompiler** is a Roblox script utility designed for developers using script executors.  
It lets you browse, filter, and attempt to view the source of scripts (`Script` and `LocalScript`) inside various Roblox services, and copy them to your clipboard — all from a sleek, in-game draggable UI.

> ⚠️ This tool is built for **executor environments** and is **not meant to run from StarterGui or Roblox Studio**.

---

## 💻 Supported Executors

| Executor     | Compatible | Clipboard | Script Source Access |
|--------------|------------|-----------|------------------------|
| Synapse X    | ✅ Full     | ✅ Yes    | ✅ Yes (mostly)       |
| Script-Ware  | ✅ Partial  | ✅ Yes    | ⚠️ Limited access     |
| KRNL         | ⚠️ Limited | ✅ Yes    | ❌ No                 |
| Fluxus       | ⚠️ Limited | ✅ Yes    | ❌ No                 |

> 📌 `Script.Source` is normally protected on the client; use at your own risk and responsibility.

---

## ✨ Features

- 🎮 GUI interface that runs inside the Roblox game
- 🎨 Sleek black-themed UI with rounded corners and draggable support
- 📂 Dropdown menu to select target service (`Workspace`, `ReplicatedStorage`, etc.)
- 🔍 Search bar to filter scripts by name
- ✅ Multi-select with checkboxes
- 📋 Copy all selected scripts (if accessible) to clipboard
- 🚫 Inaccessible sources are labeled `[Source Not Accessible]`
- ⚙️ Executor auto-detect display

---

## 📂 How to Use

1. Open your preferred Roblox script executor.
2. Paste the `DevDecompiler` script into the executor console.
3. Inject the script into the live Roblox game.
4. A GUI will appear with dropdown, search, and checkboxes.
5. Select a service (e.g., `Workspace`) from the dropdown.
6. Search or scroll through the list of available scripts.
7. Check scripts you want to copy.
8. Click **"Copy Selected"** to copy them to your clipboard.

---

## 🔒 Limitations

- Roblox protects `Script.Source` and most server-side scripts.
- Only client-visible or `LocalScript` sources are reliably accessible.
- The script uses `getclipboard()` or `setclipboard()` — must be supported by your executor.
- This tool **does not and will not bypass Roblox’s protected memory**. If a script is locked, it will be labeled as such.

---

## 📜 License

Licensed under the **Apache License, Version 2.0**.

You may use, modify, and distribute this project under the terms of the license:

Apache License
Version 2.0, January 2004
http://www.apache.org/licenses/

> http://www.apache.org/licenses/LICENSE-2.0

This software is distributed **"AS IS"** without warranties or guarantees of any kind.

---

## 🛠 Future Improvements

- Export results to `.txt` or `.lua` via `writefile()`
- Add "Select All" and "Deselect All" buttons
- Plugin version for Roblox Studio
- Live reload on game change
- Filtering by script type or folder

---

## 🤝 Contributing

Pull requests are welcome for:
- New executor support
- GUI improvements
- Additional features or fixes

Please open issues for bugs or suggestions.
