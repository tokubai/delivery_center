module DeliveryCenter
  class AlreadyDeployedError < StandardError
    def code
      1
    end
  end

  class PreviousDeployNotExistError < StandardError
    def code
      2
    end
  end
end
