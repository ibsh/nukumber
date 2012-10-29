def Before(*tags, &proc)
  unless tags.empty?
    tags.first.split(',').each do |t|
      $before_hooks[t.strip.to_sym] ||= []
      $before_hooks[t.strip.to_sym] << proc
    end
    return
  end
  $before_hooks[:each] ||= []
  $before_hooks[:each] << proc
end

def After(*tags, &proc)
  unless tags.empty?
    tags.first.split(',').each do |t|
      $after_hooks[t.strip.to_sym] ||= []
      $after_hooks[t.strip.to_sym] << proc
    end
    return
  end
  $after_hooks[:each] ||= []
  $after_hooks[:each] << proc
end
