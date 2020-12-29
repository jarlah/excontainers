defmodule Excontainers.Container do
  def new(image, opts \\ [cmd: nil, exposed_ports: nil]) do
    %Docker.ContainerConfig{image: image, cmd: opts[:cmd], exposed_ports: opts[:exposed_ports]}
  end

  def info(container_name) do
    container_id = Excontainers.Agent.lookup_container(container_name)
    {:ok, container_info} = Docker.inspect_container(container_id)

    container_info
  end

  def mapped_port(container_name, container_port) do
    container_port = set_protocol_to_tcp_if_not_specified(container_port)
    info(container_name).mapped_ports[container_port]
  end

  # TODO: this is dupicated from Docker . Refactor it
  defp set_protocol_to_tcp_if_not_specified(port) when is_binary(port), do: port
  defp set_protocol_to_tcp_if_not_specified(port) when is_integer(port), do: "#{port}/tcp"
end