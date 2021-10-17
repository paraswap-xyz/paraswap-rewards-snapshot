-- Create view for top tokens

CREATE VIEW topEthereumTokens AS
SELECT tokenAddress,
       sum(txVolume) AS tokenVolume
FROM
  (SELECT srctoken AS tokenAddress,
          srcamountusd AS txVolume
   FROM ethereum_v4
   UNION SELECT srctoken AS tokenAddress,
                srcamountusd AS txVolume
   FROM ethereum_v5
   UNION SELECT desttoken AS tokenAddress,
                destamountusd AS txVolume
   FROM ethereum_v4
   UNION SELECT desttoken AS tokenAddress,
                destamountusd AS txVolume
   FROM ethereum_v5) AS tokenTable
GROUP BY tokenAddress
HAVING sum(txVolume) > 1000000
ORDER BY tokenVolume DESC;


CREATE VIEW topPolygonTokens AS
SELECT tokenAddress,
       sum(txVolume) AS tokenVolume
FROM
  (SELECT srctoken AS tokenAddress,
          srcamountusd AS txVolume
   FROM polygon_v4
   UNION SELECT srctoken AS tokenAddress,
                srcamountusd AS txVolume
   FROM polygon_v5
   UNION SELECT desttoken AS tokenAddress,
                destamountusd AS txVolume
   FROM polygon_v4
   UNION SELECT desttoken AS tokenAddress,
                destamountusd AS txVolume
   FROM polygon_v5) AS tokenTable
GROUP BY tokenAddress
HAVING sum(txVolume) > 1000000
ORDER BY tokenVolume DESC;


CREATE VIEW topBSCTokens AS
SELECT tokenAddress,
       sum(txVolume) AS tokenVolume
FROM
  (SELECT srctoken AS tokenAddress,
          srcamountusd AS txVolume
   FROM bsc_v4
   UNION SELECT srctoken AS tokenAddress,
                srcamountusd AS txVolume
   FROM bsc_v5
   UNION SELECT desttoken AS tokenAddress,
                destamountusd AS txVolume
   FROM bsc_v4
   UNION SELECT desttoken AS tokenAddress,
                destamountusd AS txVolume
   FROM bsc_v5) AS tokenTable
GROUP BY tokenAddress
HAVING sum(txVolume) > 1000000
ORDER BY tokenVolume DESC;


CREATE VIEW topAvalancheTokens AS
SELECT tokenAddress,
       sum(txVolume) AS tokenVolume
FROM
  (SELECT srctoken AS tokenAddress,
          srcamountusd AS txVolume
   FROM avalanche_v5
   UNION SELECT desttoken AS tokenAddress,
                destamountusd AS txVolume
   FROM avalanche_v5) AS tokenTable
GROUP BY tokenAddress
HAVING sum(txVolume) > 1000000
ORDER BY tokenVolume DESC;

-- Create view for filtered txs

CREATE OR REPLACE VIEW FilteredEthereumTXs AS
SELECT *,
       1 AS network
FROM
  (SELECT id,
          augustus,
          augustusversion,
          side,
          METHOD,
          initiator,
          beneficiary,
          blocknumber,
          blockhash,
          txtimestamp,
          referrer,
          srctoken,
          desttoken,
          srcamount,
          srcamountusd,
          destamount,
          destamountusd,
          expectedamount,
          txhash,
          txgasprice,
          txgasused,
          txorigin,
          txtarget,
          NULL AS UUID,
          initiator AS userAddress
   FROM ethereum_v4
   WHERE referrer IN ('argents',
                      '3')
   UNION SELECT id,
                augustus,
                augustusversion,
                side,
                METHOD,
                initiator,
                beneficiary,
                blocknumber,
                blockhash,
                txtimestamp,
                referrer,
                srctoken,
                desttoken,
                srcamount,
                srcamountusd,
                destamount,
                destamountusd,
                expectedamount,
                ethereum_v4.txhash,
                txgasprice,
                txgasused,
                txorigin,
                txtarget,
                NULL AS UUID,
                CowSwapTxs.owner AS userAddress
   FROM ethereum_v4,
        CowSwapTxs
   WHERE initiator IN ('0x9008d19f58aabd9ed0d60971565aa8510560ab41',
                       '0x3328f5f2cecaf00a2443082b657cedeaf70bfaef')
     AND CowSwapTxs.txHash = ethereum_v4.txhash
     AND CowSwapTxs.selltoken = ethereum_v4.srctoken
   UNION SELECT id,
                augustus,
                augustusversion,
                side,
                METHOD,
                initiator,
                beneficiary,
                blocknumber,
                blockhash,
                txtimestamp,
                referrer,
                srctoken,
                desttoken,
                srcamount,
                srcamountusd,
                destamount,
                destamountusd,
                expectedamount,
                txhash,
                txgasprice,
                txgasused,
                txorigin,
                txtarget,
                NULL AS UUID,
                txorigin AS userAddress
   FROM ethereum_v4
   WHERE initiator NOT IN ('0x9008d19f58aabd9ed0d60971565aa8510560ab41',
                           '0x3328f5f2cecaf00a2443082b657cedeaf70bfaef')
     AND referrer NOT IN ('argents',
                          '3')
   UNION SELECT id,
                augustus,
                augustusversion,
                side,
                METHOD,
                initiator,
                beneficiary,
                blocknumber,
                blockhash,
                txtimestamp,
                NULL AS referrer,
                srctoken,
                desttoken,
                srcamount,
                srcamountusd,
                destamount,
                destamountusd,
                expectedamount,
                txhash,
                txgasprice,
                txgasused,
                txorigin,
                txtarget,
                UUID,
                txorigin AS userAddress
   FROM ethereum_v5) AS allTXs
WHERE srctoken in
    (SELECT tokenaddress
     FROM topethereumtokens)
  AND desttoken in
    (SELECT tokenaddress
     FROM topethereumtokens)
  AND txtimestamp < 1633730399
  AND txtimestamp > 1614977606
  AND NOT (srctoken = '0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee'
           AND desttoken = '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2')
  AND NOT (desttoken = '0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee'
           AND srctoken = '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2');


CREATE OR REPLACE VIEW FilteredPolygonTXs AS
SELECT *,
       137 AS network
FROM
  (SELECT id,
          augustus,
          augustusversion,
          side,
          METHOD,
          initiator,
          beneficiary,
          blocknumber,
          blockhash,
          txtimestamp,
          referrer,
          srctoken,
          desttoken,
          srcamount,
          srcamountusd,
          destamount,
          destamountusd,
          expectedamount,
          txhash,
          txgasprice,
          txgasused,
          txorigin,
          txtarget,
          NULL AS UUID,
          txorigin AS userAddress
   FROM polygon_v4
   UNION SELECT id,
                augustus,
                augustusversion,
                side,
                METHOD,
                initiator,
                beneficiary,
                blocknumber,
                blockhash,
                txtimestamp,
                NULL AS referrer,
                srctoken,
                desttoken,
                srcamount,
                srcamountusd,
                destamount,
                destamountusd,
                expectedamount,
                txhash,
                txgasprice,
                txgasused,
                txorigin,
                txtarget,
                UUID,
                txorigin AS userAddress
   FROM polygon_v5) AS allTXs
WHERE srctoken in
    (SELECT tokenaddress
     FROM toppolygontokens)
  AND desttoken in
    (SELECT tokenaddress
     FROM toppolygontokens)
  AND txtimestamp < 1633730399
  AND txtimestamp > 1614977606
  AND NOT (srctoken = '0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee'
           AND desttoken = '0x0d500b1d8e8ef31e21c99d1db9a6444d3adf1270')
  AND NOT (desttoken = '0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee'
           AND srctoken = '0x0d500b1d8e8ef31e21c99d1db9a6444d3adf1270');


CREATE OR REPLACE VIEW FilteredBSCTXs AS
SELECT *,
       56 AS network
FROM
  (SELECT id,
          augustus,
          augustusversion,
          side,
          METHOD,
          initiator,
          beneficiary,
          blocknumber,
          blockhash,
          txtimestamp,
          referrer,
          srctoken,
          desttoken,
          srcamount,
          srcamountusd,
          destamount,
          destamountusd,
          expectedamount,
          txhash,
          txgasprice,
          txgasused,
          txorigin,
          txtarget,
          NULL AS UUID,
          txorigin AS userAddress
   FROM bsc_v4
   UNION SELECT id,
                augustus,
                augustusversion,
                side,
                METHOD,
                initiator,
                beneficiary,
                blocknumber,
                blockhash,
                txtimestamp,
                NULL AS referrer,
                srctoken,
                desttoken,
                srcamount,
                srcamountusd,
                destamount,
                destamountusd,
                expectedamount,
                txhash,
                txgasprice,
                txgasused,
                txorigin,
                txtarget,
                UUID,
                txorigin AS userAddress
   FROM bsc_v5) AS allTXs
WHERE srctoken in
    (SELECT tokenaddress
     FROM topbsctokens)
  AND desttoken in
    (SELECT tokenaddress
     FROM topbsctokens)
  AND txtimestamp < 1633730399
  AND txtimestamp > 1614977606
  AND NOT (srctoken = '0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee'
           AND desttoken = '0xbb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c')
  AND NOT (desttoken = '0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee'
           AND srctoken = '0xbb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c');


CREATE OR REPLACE VIEW FilteredAvalancheTXs AS
SELECT *,
       43114 AS network
FROM
  (SELECT id,
          augustus,
          augustusversion,
          side,
          METHOD,
          initiator,
          beneficiary,
          blocknumber,
          blockhash,
          txtimestamp,
          NULL AS referrer,
          srctoken,
          desttoken,
          srcamount,
          srcamountusd,
          destamount,
          destamountusd,
          expectedamount,
          txhash,
          txgasprice,
          txgasused,
          txorigin,
          txtarget,
          UUID,
          txorigin AS userAddress
   FROM avalanche_v5) AS allTXs
WHERE srctoken in
    (SELECT tokenaddress
     FROM topavalanchetokens)
  AND desttoken in
    (SELECT tokenaddress
     FROM topavalanchetokens)
  AND txtimestamp < 1633730399
  AND txtimestamp > 1614977606
  AND NOT (srctoken = '0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee'
           AND desttoken = '0xb31f66aa3c1e785363f0875a1b74e27b85fd66c7')
  AND NOT (desttoken = '0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee'
           AND srctoken = '0xb31f66aa3c1e785363f0875a1b74e27b85fd66c7');


CREATE materialized VIEW AllFilteredTxs AS
  (SELECT *
   FROM FilteredEthereumTXs
   UNION SELECT *
   FROM FilteredPolygonTXs
   UNION SELECT *
   FROM FilteredBSCTXs
   UNION SELECT *
   FROM FilteredAvalancheTXs);

-- filter eligible users

CREATE materialized VIEW EligibleUsers AS
SELECT allfilteredtxs.useraddress
FROM allfilteredtxs,

  (SELECT distinct(useraddress)
   FROM userInfo
   WHERE ((network = 1
           AND balance > 28000000000000000)
          OR (network = 56
              AND balance > 250000000000000000)
          OR (network = 137
              AND balance > 20000000000000000000)
          OR (network = 43114
              AND balance > 900000000000000000))
     OR txcount > 50) AS networkFilteredUsers
WHERE allfilteredtxs.useraddress = networkFilteredUsers.useraddress
GROUP BY allfilteredtxs.useraddress
HAVING count(*) > 5;

-- Add indexes to optimise query

CREATE INDEX EligibleUsers_useraddress ON EligibleUsers(useraddress);


CREATE INDEX AllFilteredTxs_useraddress ON AllFilteredTxs(useraddress);


CREATE INDEX AllFilteredTxs_srcamountusd ON AllFilteredTxs(srcamountusd);


CREATE INDEX AllFilteredTxs_network ON AllFilteredTxs(network);

-- create queries for points

CREATE materialized VIEW txCountUserPoints AS
SELECT allfilteredtxs.useraddress,
       CASE
           WHEN count(*) > 10 THEN 1
           ELSE 0
       END AS txCountPoints
FROM allfilteredtxs,
     eligibleusers
WHERE allfilteredtxs.useraddress = eligibleusers.useraddress
GROUP BY allfilteredtxs.useraddress;


CREATE materialized VIEW maxTxValueUserPoints AS
SELECT allfilteredtxs.useraddress,
       CASE
           WHEN max(srcamountusd) > 100000 THEN 4
           WHEN max(srcamountusd) BETWEEN 10000 AND 100000 THEN 3
           WHEN max(srcamountusd) BETWEEN 1000 AND 10000 THEN 2
           WHEN max(srcamountusd) BETWEEN 100 AND 1000 THEN 1
           ELSE 0
       END AS maxTxValuePoints
FROM allfilteredtxs,
     eligibleusers
WHERE allfilteredtxs.useraddress = eligibleusers.useraddress
GROUP BY allfilteredtxs.useraddress;


CREATE materialized VIEW userVolumeUserPoints AS
SELECT allfilteredtxs.useraddress,
       CASE
           WHEN sum(srcamountusd) > 100000 THEN 4
           WHEN sum(srcamountusd) BETWEEN 10000 AND 100000 THEN 3
           WHEN sum(srcamountusd) BETWEEN 1000 AND 10000 THEN 2
           WHEN sum(srcamountusd) BETWEEN 100 AND 1000 THEN 1
           ELSE 0
       END AS userVolumePoints
FROM allfilteredtxs,
     eligibleusers
WHERE allfilteredtxs.useraddress = eligibleusers.useraddress
GROUP BY allfilteredtxs.useraddress;


CREATE materialized VIEW networkUserPoints AS
SELECT allfilteredtxs.useraddress,
       CASE
           WHEN count(DISTINCT network) > 1 THEN 1
           ELSE 0
       END AS networkPoints
FROM allfilteredtxs,
     eligibleusers
WHERE allfilteredtxs.useraddress = eligibleusers.useraddress
GROUP BY allfilteredtxs.useraddress;


CREATE VIEW TotalPoints AS
SELECT txCountUserPoints.useraddress,
       (txCountUserPoints.txCountPoints + maxTxValueUserPoints.maxTxValuePoints + userVolumeUserPoints.userVolumePoints + networkUserPoints.networkPoints) AS sumPoints
FROM txCountUserPoints,
     maxTxValueUserPoints,
     userVolumeUserPoints,
     networkUserPoints
WHERE txCountUserPoints.useraddress = maxTxValueUserPoints.useraddress
  AND txCountUserPoints.useraddress = userVolumeUserPoints.useraddress
  AND txCountUserPoints.useraddress = networkUserPoints.useraddress;


SELECT useraddress AS address,
       CASE
           WHEN sumPoints > 7 THEN 8000
           WHEN sumPoints <= 7
                AND sumPoints > 3 THEN 6000
           WHEN sumPoints <= 3 THEN 4000
       END AS earnings
FROM TotalPoints;