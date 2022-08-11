require_relative 'core'

URL = 'https://www.nasa.gov/press-release/nasa-industry-to-collaborate-on-space-communications-by-2025'

result = parse(URL)

result.each {|e| p e }