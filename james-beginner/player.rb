require 'ruby-debug'

class RubyWarrior::Turn

  def should_back_up?
    if health <= 10
      if feel.enemy? and feel.character != "a"
        true 
      end
    end
  end

  def should_rest?(previous_health)
    true if (health < 20 and feel.empty? and !taking_damage?(previous_health))
  end

  def taking_damage?(previous_health)
    debugger
    true if previous_health - health > 0
  end

  def determine_move(previous_health)
    walk!(:backward) and return if should_back_up?
    rest! and return if should_rest?(previous_health)
    if previous_health - self.health == 0
      if health < 20
        rest!
        return
      elsif feel.empty?
        walk!
        return
      else
        attack!
        return
      end
    elsif feel.empty?
      walk!
      return
    else
      if health <= 10
        walk!(:backward)
        return
      end
      attack!
      return
    end
    previous_health = health
  end
end

class Player
  def play_turn(warrior) 
    @health ||= warrior.health
    warrior.determine_move(@health)
    @health = warrior.health
  end
end

