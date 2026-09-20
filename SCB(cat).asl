// Note: The Exe just says SCB, not Steam, and not the full game name.
state("SCB", "1.222")
{
	float timer: "GameAssembly.dll", 0x42E4F18, 0xB8, 0x0;
}

state("SCB", "1.215")
{
	float timer: "GameAssembly.dll", 0x0357FF00, 0xB8, 0x0;
}

state("SCB", "1.205")
{
	float timer: "GameAssembly.dll", 0x03572458, 0x1F0, 0x78, 0x90, 0x360, 0x78, 0xB8, 0xFF0;
}

state("SCB", "1.1")
{
	float timer: "GameAssembly.dll", 0x032A5AB8, 0x98, 0x40, 0xD0, 0xB0, 0x50, 0xB8;
}

state("SCB", "1.0")
{
	float timer: "UnityPlayer.dll", 0x01CFE860, 0x138, 0x260, 0x50, 0x180, 0x0, 0xB8, 0x0;
	byte completion: "GameAssembly.dll", 0x0337CFD8, 0x48, 0xB8, 0x58, 0x20, 0x1B0, 0x338, 0xEE8;
}

state("SCB", "1.029")
{
	float timer: "UnityPlayer.dll", 0x01D1C1F0, 0x160, 0x38, 0xA8, 0x68, 0x28, 0x128, 0xFA0;
}

state("SCB", "1.015")
{
	float timer: "GameAssembly.dll", 0x033863E0, 0xD0, 0x48, 0x90, 0x3C0, 0x40, 0xB8, 0x0;
}

startup
{
	settings.Add("IL", false, "Test Segments of Runs.");
	settings.Add("split_on_collectibles", false, "This setting is currently broken");
	if (timer.CurrentTimingMethod == TimingMethod.RealTime)
    {
        var answer = MessageBox.Show(
            "Hai :3, LiveSplit is currently comparing against real time. " +
            "However, this auto-splitter kinda requires comparing against game time.\n\n" +
            "Do you wanna switch now?",
            "SCB auto-splitter",
            MessageBoxButtons.YesNo);

        if (answer == DialogResult.Yes)
            timer.CurrentTimingMethod = TimingMethod.GameTime;
    }
}

init
{
	var H = 0;
}

// The timer
gameTime
{
	if(!settings["IL"])
		return TimeSpan.FromSeconds(current.timer);
	if(settings["IL"])
		return TimeSpan.FromSeconds(current.H);
}
// Loading or Pauses
isLoading
{
	if(current.timer == old.timer && current.timer != 0)
		return true;
	return false;
}
// Resetting
reset
{
	if(current.timer == 0 && current.timer == old.timer)
		return true;
	return false;
}
// Starting
start
{
	if(settings["IL"])
		if(old.timer != current.timer)
			return true;
	if(old.timer == 0 && current.timer != 0 && old.timer != current.timer)
		return true;
}
// Collectible splits
split
{
	if(current.completion == 1 && old.completion == 0)
		return true;
	if(settings["split_on_collectibles"] && current.flagrante == (old.flagrante + 1))
		return true;
	if(settings["split_on_collectibles"] && current.quantum == (old.quantum + 1))
		return true;
}
