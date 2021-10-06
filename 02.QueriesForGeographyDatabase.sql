--12. Highest Peaks in Bulgaria
SELECT 
		mc.CountryCode,
		m.MountainRange,
		p.PeakName,
		p.Elevation
	FROM Peaks AS p
	LEFT JOIN MountainsCountries AS mc
	ON p.MountainId = mc.MountainId
	LEFT JOIN Mountains AS m
	ON mc.MountainId = m.Id
	WHERE mc.CountryCode = 'BG' AND p.Elevation > 2835
	ORDER BY p.Elevation DESC


--13. Count Mountain Ranges
SELECT CountryCode,
	   COUNT(MountainId) AS MountainRanges
	FROM MountainsCountries
		WHERE CountryCode IN ('BG', 'RU', 'US')
		GROUP BY CountryCode



--14. Countries With Rivers
SELECT TOP(5)
		c.CountryName,
        r.RiverName
	FROM Countries AS c
	LEFT JOIN CountriesRivers AS cr
	ON c.CountryCode = cr.CountryCode
	LEFT JOIN Rivers AS r
	ON cr.RiverId = r.Id
		WHERE c.ContinentCode = 'AF'
		ORDER BY c.CountryName ASC



--15. Continents and Currencies
SELECT ContinentCode, CurrencyCode, CurrencyCount AS CurrencyUsage
FROM 
	(SELECT *,

			DENSE_RANK() OVER(PARTITION BY [ContinentCode] ORDER BY CurrencyCount DESC) AS CurrencyRank
		FROM(
					SELECT ContinentCode, CurrencyCode, COUNT(CurrencyCode) AS CurrencyCount
					FROM Countries
					GROUP BY ContinentCode, CurrencyCode
		) AS CurrencyCountSubQuery
	WHERE CurrencyCount > 1
) AS CurrencyRankingSubquery
WHERE CurrencyRank = 1
ORDER BY ContinentCode



--16. Countries Without any Mountains
SELECT COUNT(*) AS [Count]
	FROM Countries AS c
	LEFT JOIN MountainsCountries AS mc
	ON c.CountryCode = mc.CountryCode
	LEFT JOIN Mountains AS m
	ON mc.MountainId = m.Id
	WHERE m.Id IS NULL



--17. Highest Peak and Longest River by Country
SELECT TOP(5) c.CountryName,
		MAX(p.Elevation) AS HighestPeakElevation,
		MAX(r.Length) AS LongestRiverLength
	FROM Countries AS c
	LEFT JOIN MountainsCountries As mc
	ON c.CountryCode = mc.CountryCode
	LEFT JOIN Mountains AS m
	ON mc.MountainId = m.Id
	LEFT JOIN Peaks AS p
	ON m.Id = p.MountainId
	LEFT JOIN CountriesRivers AS cr
	ON c.CountryCode = cr.CountryCode
	LEFT JOIN Rivers AS r
	ON cr.RiverId = r.Id
	GROUP BY c.CountryName
	ORDER BY HighestPeakElevation DESC, LongestRiverLength DESC, CountryName


--18. Highest Peak Name and Elevation by Country
SELECT TOP(5) [Country],
		CASE 
			WHEN PeakName IS NULL THEN '(no highest peak)'
			ELSE PeakName
		END AS [Highest Peak Name],
		CASE 
			WHEN Elevation IS NULL THEN 0
			ELSE Elevation
		END AS [Highest Peak Elevation],
		CASE
			WHEN MountainRange IS NULL THEN '(no mountain)' 
			ELSE MountainRange
		END AS [Mountain]
		   FROM (
				 SELECT *,
						DENSE_RANK() OVER
							(PARTITION BY [Country] ORDER BY Elevation DESC) AS [PeakRank]
					FROM (
						  SELECT c.CountryName AS [Country],
								 p.PeakName,
								 p.Elevation,
								 m.MountainRange
							FROM Countries AS c
							LEFT JOIN MountainsCountries AS mc
							ON c.CountryCode = mc.CountryCode
							LEFT JOIN Mountains AS m
							ON mc.MountainId = m.Id
							LEFT JOIN Peaks AS p
							ON m.Id = p.MountainId
						 ) AS [FullInfoQuery] 
				) AS [PeakRankingQuery]
WHERE [PeakRank] = 1
ORDER BY [Country], [Highest Peak Name]