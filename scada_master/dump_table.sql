COPY(
SELECT 
  * 
FROM 
  public.device
WHERE
  devdate < '2016-07-25 10:25') 
to 'LOCAL_PATH/scada_table.csv'
With CSV DELIMITER ',';
