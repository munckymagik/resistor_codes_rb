require 'rainbow'

COLOURS = %i[
  black
  brown
  red
  orange
  yellow
  green
  blue
  violet
  gray
  white
  gold
  silver
]

MULTS = ((0..9).to_a + [-1, -2]).map { |p| 10 ** p }

def random_code
  [
    (1..9).to_a.sample,
    (0..9).to_a.sample,
    (0..9).to_a.sample,
    (0..3).to_a.sample
  ]
end

def to_colours_names(code)
  COLOURS.values_at(*code)
end

def map_colour(colour)
  # For some reason the gold colour looks more like yellow and vice-versa
  {
    yellow: :gold,
    gold: :yellow
  }.fetch(colour, colour)
end

def render_band(str, colour)
  Rainbow(str).bg(map_colour(colour))
end

def render_code(code)
  body = Rainbow('|').color(:lightblue)
  wire = Rainbow('———').color(:darkgray)
  names = to_colours_names(code)
  bands = names.map { |c| render_band(' ', c) }
  colour_hint = " (#{names.join(' ')})"

  [wire, body, bands.join(body), body, wire, colour_hint].join
end

def code_to_number(code)
  ((code[0] * 100 + code[1] * 10 + code[2]) * MULTS[code[3]]).to_f
end

def parse_answer(answer)
  answer = answer.strip.downcase
  value = answer.to_f
  mult = case answer[-1]
         when 'm' then 1000000
         when 'k' then    1000
         else                1
         end
  value * mult
end

def key
  digits = COLOURS[0..9].each_with_index.map { |c,i| render_band(i, c) }.join(' ')
  multipliers = MULTS.each_with_index.map { |m, i| render_band(m, COLOURS.fetch(i)) }.join(' ')
  "Digits:      #{digits}\nMultipliers: #{multipliers}"
end

def prompt(code)
  puts render_code(code)
  print '? '
  parse_answer(gets)
end

begin
  puts key
  puts

  10.times do
    code = random_code
    answer = code_to_number(code)
    response = prompt(code)
    if response == answer
      puts Rainbow('CORRECT').green
    else
      puts Rainbow('WRONG').red
      puts "ANS: #{answer}, YOURS: #{response}"
    end
    puts
  end
rescue Interrupt
  puts
  puts 'Bye!'
end



