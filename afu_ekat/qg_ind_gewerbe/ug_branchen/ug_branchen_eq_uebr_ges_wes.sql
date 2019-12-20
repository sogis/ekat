 SELECT a.ogc_fid, a.xkoord, a.ykoord, a.wkb_geometry, a.gem_bfs, 
        CASE
            WHEN f.anz_arbpl > 0 THEN ((( SELECT e.schast_efak
               FROM ekat2015.emiss_quelle d
          LEFT JOIN ekat2015.quelle_emiss_efak e ON d.equelle_id = e.equelle_id
         WHERE d.equelle_id = 122 AND e.s_code = 22 AND d.archive = 0 AND e.archive = 0)) * f.anz_arbpl::numeric)::double precision
            ELSE 0::numeric::double precision
        END AS emiss_nmvoc
   FROM ekat2015.ha_raster_100 a
   LEFT JOIN ( SELECT sum(bz_noga_art_ha.anz_arbpl) AS anz_arbpl, 
            bz_noga_art_ha.xkoord, bz_noga_art_ha.ykoord
           FROM ekat2015.bz_noga_art_ha
          WHERE substr(bz_noga_art_ha.noga_art, 1, 4) = '8610'::text OR substr(bz_noga_art_ha.noga_art, 1, 4) = '8690'::text OR substr(bz_noga_art_ha.noga_art, 1, 4) = '8720'::text OR substr(bz_noga_art_ha.noga_art, 1, 4) = '8730'::text
          GROUP BY bz_noga_art_ha.xkoord, bz_noga_art_ha.ykoord) f ON a.xkoord = f.xkoord::numeric AND a.ykoord = f.ykoord::numeric
  WHERE a.archive = 0
  ORDER BY a.xkoord, a.ykoord;