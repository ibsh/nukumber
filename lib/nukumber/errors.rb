module Nukumber

  class UndefinedTestError < RuntimeError
  end

  class PendingTestError < RuntimeError
  end

  class NameCollisionError < RuntimeError
  end

  class NameCollisionWarning < RuntimeError
  end

  class SyntaxError < RuntimeError
  end

end
