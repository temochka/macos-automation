#!/usr/bin/env ruby

require 'json'

keywords = {}

Dir.glob(File.join(__dir__, '*', 'launcher.json')).each do |f|
  JSON.parse(File.read(f), symbolize_names: true)
    .fetch(:items)
    .select { |item| item[:keyword] }
    .sort_by { |item| item[:keyword] }
    .each do |item|
      focused_app = File.basename(File.dirname(f))
      keyword = item.fetch(:keyword)
      title = item.fetch(:title)
      arg = item.fetch(:arg)
      vars = item.fetch(:variables, {})

      raise "Duplicate keyword #{keyword}" if keywords.key?(keyword)


      keywords[keyword] = {
        title: "#{keyword} - #{title}",
        arg: File.join(focused_app, arg),
        variables: item.fetch(:variables, {}).merge(
          filter_script: vars[:filter_script] && File.join(focused_app, vars.fetch(:filter_script)),
          alfred_filter_script: vars[:alfred_filter_script] && File.join(focused_app, vars.fetch(:alfred_filter_script)),
          focusedapp: focused_app,
          script: File.join(focused_app, arg)
        ).compact,
      }
    end
end

puts JSON.pretty_generate(keywords)
