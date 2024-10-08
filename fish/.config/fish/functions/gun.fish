function gun --wraps='git restore --staged' --description 'alias gun=git restore --staged'
  git restore --staged $argv
        
end
