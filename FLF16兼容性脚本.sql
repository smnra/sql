SELECT
        c.version,
        DECODE(
            (CASE 
                WHEN c.version = 'FL16'  THEN 'FL16'
                WHEN c.version = 'FLF16'  THEN 'FL16'
                ELSE c.version
            END),
            'FL16', 'FL','SBTS'),
        COUNT(*)
        
FROM  
        c_Lte_Custom c
        
GROUP BY  
        c.version

        
        
        
        
(CASE WHEN c.version = 'FL16' THEN 'FL16' WHEN c.version = 'FLF16' THEN 'FL16' WHEN c.version = 'FL16A' THEN 'FL16' WHEN c.version = 'TL16' THEN 'FL16' ELSE c.version END), 'FL16', 




\(\(CASE WHEN c\.version = &apos;FL16&apos; THEN &apos;FL16&apos; WHEN c\.version = &apos;FLF16&apos; THEN &apos;FL16&apos; WHEN c\.version = &apos;FL16A&apos; THEN &apos;FL16&apos; WHEN c\.version = &apos;TL16&apos; THEN &apos;FL16&apos; ELSE c\.version END\), &apos;FL16&apos;,



 