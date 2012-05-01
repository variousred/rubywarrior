require 'ruby-debug'

class Player
  def play_turn(warrior) 
    @warrior = warrior
    @health ||= warrior.health
    determine_move
    @health = warrior.health
  end

  def should_back_up?
    if @warrior.health <= 10
      if @warrior.feel.enemy? and @warrior.feel.character != "a"
        true 
      end
    end
  end

  def should_rest?
    true if (@warrior.health < 20 and @warrior.feel.empty? and !taking_damage?)
  end

  def taking_damage?
    true if @health - @warrior.health > 0
  end

  def determine_move
    @warrior.walk!(:backward) and return if should_back_up?
    @warrior.rest! and return if should_rest?
    if @health - @warrior.health == 0
      if @warrior.health < 20
        rest!
        return
      elsif @warrior.feel.empty?
        @warrior.walk!
        return
      else
        @warrior.attack!
        return
      end
    elsif @warrior.feel.empty?
      @warrior.walk!
      return
    else
      if @warrior.health <= 10
        @warrior.walk!(:backward)
        return
      end
      @warrior.attack!
      return
    end
    @health = @warrior.health
  end
end

