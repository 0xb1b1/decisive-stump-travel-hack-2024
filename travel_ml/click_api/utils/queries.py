neighbors_query = '''
        SELECT 
            {fields},
            cosineDistance({embedding}, {column}) as score
        FROM {table}
        Where score>0
        ORDER BY score ASC
        LIMIT {knn_k}
        '''


filter_neighbors_query = '''
        SELECT 
            filename,
            cosineDistance({embedding}, {column}) as score
        FROM (select * from {table} where {filters})
        # Where score>0
        ORDER BY score ASC
        LIMIT {knn_k}
        '''

tags_query = """
        SELECT 
            tag,
            cosineDistance({embedding}, tag_embedding) as score
        FROM 
            tags_info
        where score>0
        ORDER BY score {sort}
        LIMIT {knn_k}
        """

embedding_query = '''(select {column} 
                      from images 
                      where filename=\'{filename}\')'''
