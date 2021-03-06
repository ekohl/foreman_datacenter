module ForemanDatacenter
  class DeviceInterfaceConnectionsController < ApplicationController
    before_action :set_device_interface_connection,
                  only: [:destroy, :planned, :connected]

    def index
      @device_interface_connections = DeviceInterfaceConnection.includes(
        :second_interface, first_interface: [:device]
      )
    end

    def new
      @device_interface_connection = DeviceInterfaceConnection.connected.new(
        first_interface: get_device_interface
      )
    end

    def create
      @device_interface_connection = DeviceInterfaceConnection.new(device_interface_connection_params)
      @device_interface_connection.first_interface = get_device_interface

      if @device_interface_connection.save
        redirect_to device_url(@device_interface_connection.first_interface.device),
                    notice: 'Connection was successfully created.'
      else
        process_error object: @device_interface_connection
      end
    end

    def destroy
      @device_interface_connection.destroy
      head :ok
    end

    def planned
      @device_interface_connection.planned!
      head :ok
    end

    def connected
      @device_interface_connection.connected!
      head :ok
    end

    def interfaces
      @interfaces = Device.find(params[:device_id]).free_interfaces
      render partial: 'interfaces'
    end

    private

    def set_device_interface_connection
      @device_interface_connection = DeviceInterfaceConnection.find(params[:id])
    end

    def device_interface_connection_params
      params[:device_interface_connection].
        permit(:interface_a, :interface_b, :connection_status)
    end

    def get_device_interface
      DeviceInterface.find(params[:device_interface_id])
    end
  end
end
