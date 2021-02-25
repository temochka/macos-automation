#!/usr/bin/env ruby

require 'json'
require 'shellwords'

SCRIPTS_DIR = File.join(__dir__, '..', 'applescript')
SCRIPT_TRIGGER =
  <<~APPLESCRIPT
    tell application id "com.runningwithcrayons.Alfred" to run trigger "script" in workflow "com.temochka.alfred.process" with argument "%<arg>s"
  APPLESCRIPT

script_hotkeys = Dir.glob(File.join(SCRIPTS_DIR, '*', 'launcher.json')).flat_map do |launcher|
  JSON.parse(File.read(launcher), symbolize_names: true)
    .fetch(:items)
    .select { |item| item[:anykey] }
    .map do |item|
      arg = {
        alfredworkflow: item.merge(
          variables: item.fetch(:variables, {}).merge(
            focusedapp: File.join(File.basename(File.dirname(launcher)))
          )
        )
      }

      item[:anykey]
        .merge(
          shellCommand: "osascript -e '#{format(SCRIPT_TRIGGER, arg: arg.to_json.gsub(/\"/, "\\\""))}'",
          title: item[:anykey].fetch(:title, item[:title])
        )
        .merge(
          if item[:keyword]
            {}
          else
            { onlyIn: [File.basename(File.dirname(launcher))] }
          end
        )
    end
  end

base_hotkeys = JSON.parse(File.read(File.join(__dir__, 'Anykey.base.json')), symbolize_names: true).fetch(:hotkeys, [])

puts JSON.pretty_generate(hotkeys: base_hotkeys + script_hotkeys)
