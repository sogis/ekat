 SELECT d.ogc_fid, d.xkoord, d.ykoord, d.wkb_geometry, d.gem_bfs, 
    coalesce(d.emiss_co,0) + coalesce(e.emiss_co,0) AS emiss_co, 
    coalesce(d.emiss_co2,0) + coalesce(e.emiss_co2,0) AS emiss_co2, 
    coalesce(d.emiss_nox,0) + coalesce(e.emiss_nox,0) AS emiss_nox, 
    coalesce(d.emiss_so2,0) + coalesce(e.emiss_so2,0) AS emiss_so2, 
    coalesce(e.emiss_nmvoc,0) AS emiss_nmvoc, 
    coalesce(d.emiss_pm10,0) + coalesce(e.emiss_pm10,0) AS emiss_pm10, 
    coalesce(e.emiss_ch4,0) AS emiss_ch4, 
    coalesce(e.emiss_n2o,0) AS emiss_n2o
   FROM ekat2015.ug_abfallverbr_hh_eq_feuwer d
   LEFT JOIN ekat2015.ug_abfallverbr_hh_eq_abfallverbr e ON d.xkoord = e.xkoord AND d.ykoord = e.ykoord
  ORDER BY d.xkoord, d.ykoord;
