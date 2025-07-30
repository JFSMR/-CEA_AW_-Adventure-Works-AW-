with 

source as (

    select * from {{ source('erp', 'person_person') }}

),

renamed as (

    select

    -- Chaves e identificadores principais (relevantes)

 
    CAST(businessentityid AS INT)  AS person_pk     
    , CAST(firstname AS VARCHAR)   AS first_name    
    , CAST(lastname AS VARCHAR)    As last_name 
    , CAST(persontype AS VARCHAR)  AS person_type  
    

    --Colunas técnicas ou complementares que não respondem diretamente às perguntas
    
    --, CAST(middlename AS VARCHAR) AS middle_name
     --, CAST(suffix AS VARCHAR) AS suffix -- Ocultado não a valor nessa coluna SURRIX
    --, CAST(namestyle AS BOOLEAN ) AS name_style
   --- , CAST(title AS VARCHAR) AS title
    --, CAST(emailpromotion AS INT) AS emailpromotion   -- Oculto a diposição da equipe de markentig
    --, CAST(additionalcontactinfo AS VARCHAR) AS additional_contact_info
    --, CAST(demographics AS VARCHAR) AS demographics    
    --, CAST(modifieddate AS DATE) AS modified_date
    --, CAST(rowguid AS VARCHAR)     AS rowguid

    from source

)

select * from renamed
