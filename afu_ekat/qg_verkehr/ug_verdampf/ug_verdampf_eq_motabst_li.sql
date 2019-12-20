SELECT min(c.ogc_fid) AS ogc_fid, min(c.xkoord)::numeric AS xkoord, 
    min(c.ykoord)::numeric AS ykoord, c.wkb_geometry, min(c.gem_bfs) AS gem_bfs, 
    sum(c.emiss_nmvoc) AS emiss_nmvoc
   FROM ( SELECT k.ogc_fid, k.xkoord, k.ykoord, k.wkb_geometry, k.gem_bfs, 
                CASE
                    WHEN k.arb_plaetze_zone > 0::numeric OR k.einw_zone > 0::numeric THEN (k.p00btot + k.b05empts2 + k.b05empts3)::double precision * ((( SELECT efak_kalt_tank.efak
                       FROM ekat2015.efak_kalt_tank
                      WHERE efak_kalt_tank.efak_code = 3 AND efak_kalt_tank.fhz_art = 'LNF'::text)) * k.stops_li * 365::double precision / 1000::double precision) / (k.arb_plaetze_zone + k.einw_zone)::double precision
                    ELSE 0::double precision
                END AS emiss_nmvoc
           FROM ( SELECT a.ogc_fid, a.xkoord, a.ykoord, 
                    a.wkb_geometry_ha_rast AS wkb_geometry, a.gem_bfs, 
                    b.arb_plaetze_zone, b.einw_zone, b.stops_li, a.vk_zone, 
                    a.p00btot, a.b05empts2, a.b05empts3
                   FROM ekat2015.intersec_vk_zone_ha_raster a
LEFT JOIN ( SELECT vk_zonen.ogc_fid, 
                            vk_zonen.wkb_geometry, 
                            vk_zonen.gmde, 
                            vk_zonen.name, 
                            vk_zonen.zonennummer, 
                            vk_zonen.laenge,  
                            vk_zonen.starts_pw, 
                            vk_zonen.starts_li, 
                            vk_zonen.stops_pw, 
                            vk_zonen.stops_li, 
                            vk_zonen.dtv_pw, 
                            vk_zonen.dtv_li, 
                            vk_zonen.arb_plaetze_zone, 
                            vk_zonen.einw_zone
                           FROM ekat2015.vk_zonen) b ON a.vk_zone::double precision = b.zonennummer) k) c
  GROUP BY c.wkb_geometry
  ORDER BY min(c.xkoord)::numeric, min(c.ykoord)::numeric;