USE social_media_student;


SELECT * from Social_media_impact_on_life;


-- Platform Metrics Overview:

SELECT 
	Primary_Platform AS Platforme,
	COUNT(Student_ID) AS Total_Students, 
	ROUND(AVG(Daily_Usage_Hours), 2) AS Average_Daily_Usage_Hours,
	ROUND(AVG(Academic_Performance_GPA), 2) AS Average_Academic_Performance_GPA
FROM Social_media_impact_on_life
GROUP BY Primary_Platform
ORDER BY Total_Students DESC;



-- Late-Night Impact:

SELECT 
	Late_Night_Usage,
	COUNT(Student_ID) AS Total_Students, 
	ROUND(AVG(Sleep_Duration_Hours), 2) AS Average_Sleep_Duration_Hours,
	ROUND(AVG(Sleep_Quality_Score), 2) AS Average_Sleep_Quality_Score
FROM Social_media_impact_on_life
GROUP BY Late_Night_Usage;



-- Usage Intensity Tiering:

SELECT 
	CASE
		WHEN Daily_Usage_Hours > 6 THEN 'High Usage'
		WHEN Daily_Usage_Hours BETWEEN 3 AND 6 THEN 'Moderate Usage'
		ELSE 'Low Usage'
	END AS Daily_Usage_Hours_Note,
	COUNT(Student_ID) AS Total_Students, 
	ROUND(AVG(Mental_Health_Index), 2) AS Average_Mental_Health_Index,
	ROUND(AVG(Academic_Performance_GPA), 2) AS Average_Academic_Performance_GPA
FROM Social_media_impact_on_life
WHERE Academic_Performance_GPA IS NOT NULL
GROUP BY CASE
		WHEN Daily_Usage_Hours > 6 THEN 'High Usage'
		WHEN Daily_Usage_Hours BETWEEN 3 AND 6 THEN 'Moderate Usage'
		ELSE 'Low Usage'
	END;



	-- Negative Impact Ratio by Academic Level:

SELECT 
	Academic_Level,
	COUNT(Student_ID) AS Total_Students, 
	COUNT(CASE WHEN Overall_Impact = 'Negative' THEN 1 END) AS negative_impact_count,
	ROUND(100*COUNT(CASE WHEN Overall_Impact = 'Negative' THEN 1 END)/COUNT(*),2) AS negative_impact_percentage
FROM Social_media_impact_on_life
GROUP BY Academic_Level;


-- GPA Deviation from Platform Average

SELECT 
    Student_ID,
    Academic_Level,
    Primary_Platform,
    Academic_Performance_GPA,
    ROUND(
        AVG(Academic_Performance_GPA) OVER (PARTITION BY Primary_Platform), 
        2
    ) AS platform_avg_gpa,
    ROUND(
        Academic_Performance_GPA - AVG(Academic_Performance_GPA) OVER (PARTITION BY Primary_Platform), 
        2
    ) AS gpa_deviation
FROM Social_media_impact_on_life
WHERE Academic_Performance_GPA IS NOT NULL
ORDER BY Primary_Platform, Student_ID;