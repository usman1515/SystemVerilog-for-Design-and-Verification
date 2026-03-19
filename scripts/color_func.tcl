# Example usage
# print_red "Hello, this text is in red color!"

proc print_red {input_string} {
    puts -nonewline "\033\[1;31m"; # set RED color for text
    puts "\n------------------------------------------------------------"
    puts $input_string
    puts "------------------------------------------------------------\n"
    puts -nonewline "\033\[0m"; # reset color
}

proc print_green {input_string} {
    puts -nonewline "\033\[1;32m"; # set GREEN color for text
    puts "\n------------------------------------------------------------"
    puts $input_string
    puts "------------------------------------------------------------\n"
    puts -nonewline "\033\[0m"; # reset color
}

proc print_yellow {input_string} {
    puts -nonewline "\033\[1;33m"; # set YELLOW color for text
    puts "\n------------------------------------------------------------"
    puts $input_string
    puts "------------------------------------------------------------\n"
    puts -nonewline "\033\[0m"; # reset color
}

proc print_blue {input_string} {
    puts -nonewline "\033\[1;34m"; # set BLUE color for text
    puts $input_string
    puts -nonewline "\033\[0m"; # reset color
}

proc print_white {input_string} {
    puts -nonewline "\033\[1;37m"; # set WHITE color for text
    puts $input_string
    puts -nonewline "\033\[0m"; # reset color
}
