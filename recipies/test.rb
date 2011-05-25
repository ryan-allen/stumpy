Stumpy::Recipies.define do
  step 'Making an empty file.' do
    setup(lambda do 
      # touch '/tmp/the-time' failed with no warning, lispy problem?
      `touch /tmp/the-time`
    end)

    verify(lambda do
      File.exist?('/tmp/the-time')
    end)
  end

  step 'Writing the date into the file.' do
    setup(lambda do
      open('/tmp/the-time', 'w') do |f|
        f.write(Time.now)
      end
    end)

    verify(lambda do
      File.new('/tmp/the-time').size != 0
    end)
  end
end
