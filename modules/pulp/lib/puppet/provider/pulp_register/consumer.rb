Puppet::Type.type(:pulp_register).provide(:consumer) do
  desc "Register/unregister a pulp consumer"

  commands :consumer => '/bin/pulp-consumer'
  def exists?
    output = consumer('status')
    output.match(/This consumer is registered to the server/)
  end

  def create
    extra = []
    if resource[:display_name]
      extra << '--display-name'
      extra << resource[:display_name]
    end
    if resource[:description]
      extra << '--description'
      extra << resource[:description]
    end
    if resource[:note]
      extra << '--note'
      extra << resource[:note]
    end

    consumer('-u', resource[:user], '-p', resource[:pass], 'register', '--consumer-id', resource[:name] , extra)
  end

  def destroy
    consumer('unregister')
  end

  def display_name
    resource[:display_name]
  end

  def display_name=(value)
    consumer('update', '--display-name', resource[:display_name])
  end

  def description
    resource[:description]
  end

  def description=(value)
    consumer('update', '--description', resource[:description])
  end

  def note
    resource[:note]
  end

  def note=(value)
    consumer('update', '--note', resource[:note])
  end

end
