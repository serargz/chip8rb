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

    # Emulates a processor cycle
    def emulate_cycle
      opcode = get_opcode
      exec(opcode)

      timers_tick

      # Simulate 60Hz
      sleep(1.0/60.0)
    end

    # Executes an opcode. For a complete opcode list, check:
    # http://en.wikipedia.org/wiki/CHIP-8#Opcode_table
    def exec(opcode)
      # Check the left most byte
      case 0xF000 & opcode

      when 0x0000
        # 0nnn is ignored by modern intepreters/emulators
        # clear_screen if opcode == 0x00E0
        # return_from_subroutine if opcode == 0x00EE

      when 0xA000 # ANNN: Sets I to the address NNN
        # TODO
      end
    end

    # As our memory stores byte by byte, we need to concat
    # two adjacent bytes to get the opcode.
    def get_opcode
      return @memory[@pc] << 8 | @memory[@pc + 1]
    end

    # Checks whether the program fits in memory or not
    def check_program_size(program)
      raise 'Program does not fit in memory' if program.size > 4096 - 0x200
    end

    # Decrements timers if are > 0
    def timers_tick
      @delay_timer -= 1 if @delay_timer > 0
      if @sound_timer > 0
        puts "BEEP!" if @sound_timer == 1
        @sound_timer -= 1
      end
    end
  end

  # Increments instruction pointer
  # The parameter determines how many instructions (default: 1)
  def inc_pc(n=1)
    @pc += n*2
  end

  # opcode implementations
  # TODO: Extract to class

  # 0x00E0: Clear Screen
  def cls
    @gfx.fill(0)
  end

  # 0x00EE: Return from a soubroutine
  # Sets the program counter to the address at the top of the stack,
  # then subtracts 1 from the stack pointer.
  def ret
    @pc = @stack[@sp]
    @sp -= 1
  end

  # 0x1nnn: JP addr
  # Jumps to location nnn. Sets the program counter to nnn
  def jp_addr(addr)
    @pc = addr
  end

  # 0x2nnn: CALL addr
  # Increments the stack pointer, then puts the current PC on the
  # top of the stack. The PC is then set to nnn.
  def call_addr(addr)
    @sp +=1
    @stack[@sp] = @pc
    @pc = addr
  end

  # 0x3xkk: SE Vx, byte
  # Skip next instruction if Vx == kk
  def se_vx_byte(x, kk)
    # We skip 1 instruction (each instruction consists of 2 bytes)
    inc_pc(2) && return if @v[x] == kk

    # If not equal, just go to the next instruction
    inc_pc
  end

  # 0x4xkk: SNE Vx, byte
  # Skip next instruction if Vx != kk
  def sne_vx_byte(x, kk)
    # We skip 1 instruction (each instruction consists of 2 bytes)
    inc_pc(2) && return unless @vpx[x] == kk
    # If equal, just go to the next instruction
    inc_pc
  end

  # 0x5xy0: SE Vx, Vy
  # Skip next instruction if Vx == Vy
  def se_vx_vy(x, y)
    # We skip 1 instruction (each instruction consists of 2 bytes)
    inc_pc(2) && return if @v[x] == @v[y]

    # If not equal, just go to the next instruction
    inc_pc
  end

  # 0x6xkk: LD Vx, byte
  # Loads the value of kk in Vx
  def ld_vx_byte(x, byte)
    @v[x] = byte
    inc_pc
  end

  # 0x7xkk: ADD Vx, byte
  # Adds the value of kk to Vx
  def add_vx_byte(x, kk)
    @v[x] += kk
    inc_pc
  end
end
