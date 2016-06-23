module Katello

  COMMON_PARAMS = Proc.new do

    ensurable

    # make ensure present default
    define_method(:managed?) { true }

    newparam(:user)

    newparam(:password)

    newparam(:org)

  end
end
