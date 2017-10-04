defmodule SCADAMaster.Schema.Mailer do
  use Swoosh.Mailer, otp_app: :scada_master
end

defmodule SCADAMaster.Schema.UserEmail do
  import Swoosh.Email

  def welcome_email do
    new()
    |> to("rmatteoda@gmail.com")
    |> from({"SCADA", "metodosunrc@egmail.com"})
    |> subject("Reporte SCADA")
    |> html_body("<h1>Reporte </h1>")
    |> text_body("reporte scada collector \n")
  end
end
