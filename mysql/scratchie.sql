SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

DROP TABLE IF EXISTS `xtra_lottery`;
CREATE TABLE IF NOT EXISTS `xtra_lottery` (
  `uid` varchar(32) NOT NULL,
  `noScratchies` smallint(5) unsigned NOT NULL DEFAULT '0',
  `number` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `xtra_lottery_winner`;
CREATE TABLE IF NOT EXISTS `xtra_lottery_winner` (
`uid` int(11) NOT NULL,
  `account_uid` varchar(32) NOT NULL,
  `prize` varchar(60) NOT NULL,
  `source` varchar(30) NOT NULL DEFAULT 'VehiclePrize',
  `sent` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


ALTER TABLE `xtra_lottery`
 ADD PRIMARY KEY (`uid`);

ALTER TABLE `xtra_lottery_winner`
 ADD PRIMARY KEY (`uid`), ADD KEY `source` (`source`);


ALTER TABLE `xtra_lottery_winner`
MODIFY `uid` int(11) NOT NULL AUTO_INCREMENT;