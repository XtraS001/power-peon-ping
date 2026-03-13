import { spawn } from "child_process";

function playSound() {
  spawn("powershell", [
    "-NoProfile",
    "-Command",
    "(New-Object Media.SoundPlayer 'C:\\Windows\\Media\\notify.wav').PlaySync()",
  ]);
}

function playSound1() {
  spawn("powershell", [
    "-NoProfile",
    "-Command",
    "(New-Object Media.SoundPlayer 'C:\\Users\\Asus\\Documents\\MyProject\\power-peon-ping\\audio\\PeasantReady1.wav').PlaySync()",
  ]);
}

function playSound2() {
  spawn("powershell", [
    "-NoProfile",
    "-Command",
    "(New-Object Media.SoundPlayer 'C:\\Users\\Asus\\Documents\\MyProject\\power-peon-ping\\audio\\peon_jobs_done.wav').PlaySync()",
  ]);
}

export const PingPlugin = async () => {
  return {
    event: async ({ event }: { event: any }) => {
      if (event.type === "message.updated") {
        const info = event.properties?.info;

        // Prompt sent
        if (info?.role === "user" && !info?.summary) {
          playSound1();
        }
      }
      if (event.type === "session.idle") {
        playSound2();
      }
    },
  };
};
