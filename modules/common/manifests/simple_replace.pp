define common::simple_replace($file, $pattern, $replacement) {
  exec { "/bin/sed -i -e \"s/${pattern}/${replacement}/g\" ${file}":
    unless => "/bin/grep -E \"${replacement}\" ${file}",
    onlyif => "/bin/grep -E \"${pattern}\" ${file}",
  }
}
