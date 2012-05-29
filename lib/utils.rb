require 'awesome_print'

module Utils

  def debug_log obj
    if $DEBUG_ON
      term_width, term_height = detect_terminal_size
      puts '-' * term_width
      ap obj
      puts '-' * term_width
    end
  end

  # Lifted from https://github.com/cldwalker/hirb/blob/master/lib/hirb/util.rb#L61-71
  #
  def detect_terminal_size
    `stty size`.scan(/\d+/).map { |s| s.to_i }.reverse
  end  
end