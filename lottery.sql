-- phpMyAdmin SQL Dump
-- version 4.2.12deb2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Oct 24, 2015 at 03:57 PM
-- Server version: 5.5.44-0+deb8u1
-- PHP Version: 5.6.13-0+deb8u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `a3s_exile`
--

-- --------------------------------------------------------

--
-- Table structure for table `xtra_lottery`
--

CREATE TABLE IF NOT EXISTS `xtra_lottery` (
  `uid` varchar(32) NOT NULL,
  `noScratchies` smallint(5) unsigned NOT NULL DEFAULT '0',
  `number` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `xtra_lottery_winner`
--

CREATE TABLE IF NOT EXISTS `xtra_lottery_winner` (
`uid` int(11) NOT NULL,
  `account_uid` varchar(32) NOT NULL,
  `prize` varchar(60) NOT NULL,
  `sent` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `xtra_lottery`
--
ALTER TABLE `xtra_lottery`
 ADD PRIMARY KEY (`uid`);

--
-- Indexes for table `xtra_lottery_winner`
--
ALTER TABLE `xtra_lottery_winner`
 ADD PRIMARY KEY (`uid`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `xtra_lottery_winner`
--
ALTER TABLE `xtra_lottery_winner`
MODIFY `uid` int(11) NOT NULL AUTO_INCREMENT;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
