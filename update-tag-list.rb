#!/usr/bin/env ruby

version = ARGV[0]

distributions = [
  "debian",
  "alpine",
]
readme_md_path = File.join(__dir__, "README.md")
readme_md_content = ""
link_added = false
File.readlines(readme_md_path).each do |line|
  case line
  when /\A\|/
    case line
    when / latest /
      components = line.split("|")

      version_width = components[1].size - 2
      tags_width = components[3].size - 2
      path_width = components[4].size - 2

      distributions.each do |distribution|
        components[1] = " %-#*s " % [version_width, version]

        tags = ["#{version}-#{distribution}", "latest-#{distribution}"]
        tags << "latest" if distribution == "debian"
        components[3] = " %-#*s " % [tags_width, tags.join(", ")]

        path = "[#{distribution}/Dockerfile][#{version}-#{distribution}]"
        components[4] = " %-#*s " % [path_width, path]
        readme_md_content << components.join("|")
      end

      readme_md_content << line.gsub(/, latest(?:-[^, ]+|)/) do |matched|
        " " * matched.size
      end
    when / latest-/
      readme_md_content << line.gsub(/, latest-[^, ]+[, ]/) do |matched|
        " " * matched.size
      end
    else
      readme_md_content << line
    end
  when /\A\[.+?\]: /
    unless link_added
      distributions.each do |distribution|
        link = "[#{version}-#{distribution}]: "
        link << "https://github.com/groonga/docker"
        link << "/tree/#{version}/#{distribution}/Dockerfile\n"
        readme_md_content << link
      end
      link_added = true
    end
    readme_md_content << line
  else
    readme_md_content << line
  end
end

File.open(readme_md_path, "w") do |readme_md|
  readme_md.print(readme_md_content)
end
