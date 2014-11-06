module Chip8rb

  # This CHIP-8 emulator is based on the instructions given in:
  # http://www.multigesture.net/articles/how-to-write-an-emulator-chip-8-interpreter/
  class Emaulator

    def initialize
      # Chip-8 has 4k memory (0x100)
      @memory = Array.new(4096)

      # CPU Registers:
      # . 0-E general purpose
      # . F carry flag
      @v = Array.new(16)

      # Index register
      @i = 0

      # Program counter (instruction pointer)
      # Starts at 0x200
      @pc = 0x200

      # The graphics are black and white and the screen has
      # a total of 2048 (64x32)
      @gfx = Array.new(64*32)

      # Timer registers, count at 60Hz.
      # When set above zero, they will count down to zero.
      @delay_timer = 0

      # The system's buzzer sounds whenever the sound
      # timer reaches zer.
      @sound_timer = 0

      # Stack. The system has 16 levels of stack.
      @stack = Array.new(16)

      # Stack pointer
      @sp = 0

      # HEX based keypad.
      @key = Array.new(16)

      # Set the fontset
      @memory[0...80] = [
        0xF0, 0x90, 0x90, 0x90, 0xF0, # 0
        0x20, 0x60, 0x20, 0x20, 0x70, # 1
        0xF0, 0x10, 0xF0, 0x80, 0xF0, # 2
        0xF0, 0x10, 0xF0, 0x10, 0xF0, # 3
        0x90, 0x90, 0xF0, 0x10, 0x10, # 4
        0xF0, 0x80, 0xF0, 0x10, 0xF0, # 5
        0xF0, 0x80, 0xF0, 0x90, 0xF0, # 6
        0xF0, 0x10, 0x20, 0x40, 0x40, # 7
        0xF0, 0x90, 0xF0, 0x90, 0xF0, # 8
        0xF0, 0x90, 0xF0, 0x10, 0xF0, # 9
        0xF0, 0x90, 0xF0, 0x90, 0x90, # A
        0xE0, 0x90, 0xE0, 0x90, 0xE0, # B
        0xF0, 0x80, 0x80, 0x80, 0xF0, # C
        0xE0, 0x90, 0x90, 0x90, 0xE0, # D
        0xF0, 0x80, 0xF0, 0x80, 0xF0, # E
        0xF0, 0x80, 0xF0, 0x80, 0x80  # F
      ]
    end

    # Loads a program into memory
    def load_program(program)
      check_program_size(program)
      program_end = program.size + 0x200
      @memory[0x200...program_end] = program
    end

    def run(program)
      # 1. Setup graphics
      # 2. Setup input
      # 3. Initialize / Load program into memory

      load_program(program)

      # 4. Emulation loop
      loop do
        # 5. Emulate one cycle
        # 6. If the draw flag is set, update screen
        # 7. Update key press state (Press and Release)
      end
    end

  private

    def emulate_cycle
      opcode = get_opcode

      # Simulate 60Hz
      sleep(1.0/60.0)
    end

    # As our memory stores byte by byte, we need to concat
    # two adjacent bytes to get the opcode.
    def get_opcode
      return @memory[@pc] << 8 | @memory[@pc + 1]
    end

    def check_program_size(program)
      raise 'Program does not fit in memory' if program.size > 4096 - 0x200
    end
  end
end
