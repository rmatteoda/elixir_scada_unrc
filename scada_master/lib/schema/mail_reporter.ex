defmodule SCADAMaster.Schema.Mailer do
  use Swoosh.Mailer, otp_app: :scada_master
end

defmodule SCADAMaster.Schema.ReportEmail do
  import Swoosh.Email

  def report(csv_file, substation_name) do 
    new(attachment: csv_file)
    |> to("fernando.magnago@gmail.com")
    |> cc("rmatteoda@gmail.com")
    |> from({"SCADA", "metodosunrc@gmail.com"})
    |> subject("Reporte for substation: " <> substation_name)
    |> html_body("<h2>CSV Files SCADA UNRC</h2>")
    |> text_body("reporte scada in csv files \n")
  end
end
