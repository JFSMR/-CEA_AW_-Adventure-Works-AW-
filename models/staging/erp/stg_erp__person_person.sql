with 

source as (

    select * from {{ source('erp', 'person_person') }}

),

renamed as (

    select
 -- AS COLUNAS EM TEXTO FORAM ESCOLHIDO POR MOTIVO QUE NÃO AGREGA VALOR NAS CONSULTAS
    CAST(businessentityid AS INT) AS businessentity_pk 
    --, CAST(persontype AS VARCHAR) AS person_type
    --, CAST(namestyle AS BOOLEAN ) AS name_style
   --- , CAST(title AS VARCHAR) AS title
    , CAST(firstname AS VARCHAR) AS firs_tname
    --, CAST(middlename AS VARCHAR) AS middle_name
    , CAST(lastname AS VARCHAR) AS last_name
    --, CAST(suffix AS VARCHAR) AS suffix -- Ocultado não a valor nessa coluna SURRIX
    , CAST(rowguid AS VARCHAR) AS rowguid
    --, CAST(emailpromotion AS INT) AS emailpromotion   -- Oculto a diposição da equipe de markentig
    --, CAST(additionalcontactinfo AS VARCHAR) AS additional_contact_info
    --, CAST(demographics AS VARCHAR) AS demographics    
    , CAST(modifieddate AS DATE) AS modified_date

    from source

)

select * from renamed
