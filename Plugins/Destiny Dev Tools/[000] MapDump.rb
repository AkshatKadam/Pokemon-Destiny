#===============================================================================
# Destiny Dev Tools - Map Dump
#-------------------------------------------------------------------------------
# Exports every map's structure (size, events, event coords, triggers, page
# conditions, key commands, warps, sprites) to a plain-text file so it can be
# read outside the engine for event planning.
#
# HOW TO RUN (debug mode):
#   Option A: Pause menu -> Debug -> "Dump Map Data (Destiny)"
#   Option B: anywhere a console is available, call:  DestinyDev.dump_maps
#
# Output file: "dev_map_dump.txt" in the game folder (next to Game.exe).
# This plugin is DEBUG-ONLY tooling; remove the folder before a public release.
#===============================================================================

module DestinyDev
  module_function

  # Human-readable labels for the RMXP event command codes we care about.
  CMD_LABELS = {
    101 => "Text",          102 => "Choices",       103 => "InputNumber",
    111 => "CondBranch",    112 => "Loop",          115 => "BreakLoop",
    117 => "CallCommonEvt", 118 => "Label",         119 => "JumpToLabel",
    121 => "CtrlSwitch",    122 => "CtrlVariable",  123 => "CtrlSelfSwitch",
    125 => "ChangeGold",    126 => "ChangeItems",
    201 => "TransferPlayer",202 => "SetEventLoc",   203 => "ScrollMap",
    209 => "SetMoveRoute",  223 => "ScreenTone",    224 => "ScreenFlash",
    231 => "ShowPicture",   241 => "PlayBGM",       245 => "PlayBGS",
    249 => "PlayME",        250 => "PlaySE",        251 => "StopSE",
    314 => "RecoverAll",    351 => "CallMenu",      352 => "CallSave",
    355 => "Script",        356 => "ScriptCmd"
  }

  TRIGGERS = ["Action", "PlayerTouch", "EventTouch", "Autorun", "Parallel"]

  def trim(str, n = 60)
    s = str.to_s.gsub(/\r?\n/, " ").strip
    s.length > n ? s[0, n] + "…" : s
  end

  def page_condition_str(cond)
    parts = []
    parts << "Switch##{cond.switch1_id}=ON"                 if cond.switch1_valid
    parts << "Switch##{cond.switch2_id}=ON"                 if cond.switch2_valid
    parts << "Var##{cond.variable_id}>=#{cond.variable_value}" if cond.variable_valid
    parts << "SelfSw '#{cond.self_switch_ch}'=ON"           if cond.self_switch_valid
    parts.empty? ? "none" : parts.join(", ")
  end

  def command_str(cmd)
    label = CMD_LABELS[cmd.code] || "code#{cmd.code}"
    case cmd.code
    when 101 then "Text: \"#{trim(cmd.parameters[0])}\""
    when 102 then "Choices: #{cmd.parameters[0].inspect}"
    when 121
      s, e, st = cmd.parameters
      "CtrlSwitch ##{s}#{e != s ? "-#{e}" : ""} = #{st == 0 ? "ON" : "OFF"}"
    when 123
      "CtrlSelfSwitch '#{cmd.parameters[0]}' = #{cmd.parameters[1] == 0 ? "ON" : "OFF"}"
    when 122 then "CtrlVariable: #{trim(cmd.parameters.inspect)}"
    when 201
      _, mid, x, y, dir = cmd.parameters
      "TransferPlayer -> Map#{format("%03d", mid)} (#{x},#{y}) dir#{dir}"
    when 209 then "SetMoveRoute (event #{cmd.parameters[0]})"
    when 111 then "CondBranch: #{trim(cmd.parameters.inspect, 50)}"
    when 117 then "CallCommonEvent ##{cmd.parameters[0]}"
    when 241, 245, 249, 250
      "#{label}: #{trim((cmd.parameters[0].name rescue cmd.parameters[0]).to_s, 30)}"
    when 355, 356 then "#{label}: #{trim(cmd.parameters[0])}"
    else label
    end
  end

  def dump_maps
    infos = load_data("Data/MapInfos.rxdata")
    out = []
    out << "# Destiny Map Dump"
    out << "# Generated: #{Time.now}"
    out << "# Format: MAP[id] \"name\" (WxH)  ->  events with @(x,y), trigger, conditions, key commands"
    out << ""
    infos.keys.sort.each do |id|
      name = infos[id].name
      file = sprintf("Data/Map%03d.rxdata", id)
      next unless FileTest.exist?(file)
      map = load_data(file)
      out << "=" * 70
      out << "MAP[#{format("%03d", id)}] \"#{name}\"  (#{map.width}x#{map.height})"
      ev_ids = map.events.keys.sort
      if ev_ids.empty?
        out << "  (no events)"
        out << ""
        next
      end
      ev_ids.each do |eid|
        ev = map.events[eid]
        out << "  EV[#{eid}] \"#{ev.name}\" @(#{ev.x},#{ev.y})  pages=#{ev.pages.length}"
        ev.pages.each_with_index do |pg, pi|
          spr = pg.graphic.character_name
          spr = spr.empty? ? "(invisible)" : spr
          out << "    p#{pi + 1}: trigger=#{TRIGGERS[pg.trigger]}  cond=[#{page_condition_str(pg.condition)}]  sprite=#{spr}"
          # Summarize commands (skip empty list entries code 0 and text continuations).
          cmds = pg.list.reject { |c| c.code == 0 }
          if cmds.empty?
            out << "        (empty)"
          else
            shown = 0
            cmds.each do |c|
              next if c.code == 108 || c.code == 408 # comments
              out << "        - #{command_str(c)}"
              shown += 1
              if shown >= 40
                out << "        … (#{cmds.length - shown} more commands)"
                break
              end
            end
          end
        end
      end
      out << ""
    end
    File.open("dev_map_dump.txt", "w") { |f| f.write(out.join("\n")) }
    out.length
  end
end

# --- AUTO-DUMP AT BOOT (debug only) -------------------------------------------
# Runs once every time the game launches in debug/test-play. Writes
# dev_map_dump.txt to the game folder. No menus needed. Guarded so a failure
# can never crash the game.
if $DEBUG
  begin
    n = DestinyDev.dump_maps
    msg = "[Destiny Dev Tools] Wrote dev_map_dump.txt (#{n} lines) to #{Dir.pwd}"
    if defined?(echoln) then echoln msg else p msg end
  rescue => e
    p "[Destiny Dev Tools] dump failed: #{e.class}: #{e.message}"
    p e.backtrace[0, 6]
  end
end

# Also register a Debug-menu command as a backup (guarded against API drift).
begin
  MenuHandlers.add(:debug_menu, :destiny_dump_maps, {
    "name"        => _INTL("Dump Map Data (Destiny)"),
    "parent"      => :main,
    "description" => _INTL("Export all maps' events/coords to dev_map_dump.txt"),
    "always_show" => false,
    "effect"      => proc {
      lines = DestinyDev.dump_maps
      pbMessage(_INTL("Wrote dev_map_dump.txt ({1} lines) to the game folder.", lines))
    }
  })
rescue => e
  echoln "[Destiny Dev Tools] Debug menu hook skipped: #{e.message}" if defined?(echoln)
end
