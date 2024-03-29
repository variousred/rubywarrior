require 'ruby-debug'

class Player
  def play_turn(warrior) 
    @warrior = warrior
    @health ||= warrior.health
    determine_and_take_move
    @health = warrior.health
  end

protected

  def determine_and_take_move
    @warrior.walk!(:backward) and return if should_walk_backward?
    @warrior.rest! and return if should_rest?
    @warrior.attack! and return if should_attack?
    @warrior.rescue!(should_free_captive?) and return if should_free_captive?
    @warrior.walk! and return if should_walk_forward?
    @health = @warrior.health
  end

  def should_walk_forward?
    true if @warrior.feel.empty?
  end

  def should_walk_backward?
    @hit_back_wall = true if @warrior.feel(:backward).wall?
    if @warrior.health <= 10
      if @warrior.feel.enemy? and @warrior.feel.character != "a"
        true 
      end
    elsif @warrior.feel(:backward).empty? and !@hit_back_wall
      true
    end
  end

  def should_rest?
    true if (@warrior.health < 20 and @warrior.feel.empty? and !taking_damage?)
  end

  def taking_damage?
    true if @health - @warrior.health > 0
  end

  def should_attack?
    true if @warrior.feel.enemy?
  end

  def should_free_captive?
    if @warrior.feel.captive? 
      :forward 
    elsif @warrior.feel(:backward).captive?
      :backward
    end
  end


end

