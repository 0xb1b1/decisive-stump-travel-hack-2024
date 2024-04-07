from typing import List, Any

from click_api.utils.queries import (neighbors_query, tags_query, embedding_query)

tables = ['images', 'tags', 'labels', 'metas']


def get_filter_string(filters):
    filter_list = []

    for filter in filters:
        if filters[filter] is not None:
            if isinstance(filters[filter], list) and len(filters[filter]) == 0:
                continue
            cur_filter = ''
            if filter == 'number_of_people':
                numbers = []
                for number in filters[filter]:
                    cur_filter = ' '
                    if number == 0:
                        cur_filter = f'{filter} = 0'
                    elif number == 1:
                        cur_filter = f'{filter} >= 1 and {filter} <= 5'
                    elif number == 2:
                        cur_filter = f'{filter} >= 5 and {filter} <= 5'
                    elif number == 3:
                        cur_filter = f'{filter} >= 15'
                    if len(filters[filter]) > 1:
                        cur_filter = f'({cur_filter})'
                    numbers.append(cur_filter)
                cur_filter = ' or '.join(numbers)
            elif filter == 'tags':
                if isinstance(filters[filter], list):
                    multiple_filters = ", ".join([f"\'{value.lower()}\'" for value in filters[filter]])
                    if len(filters[filter]) > 1:
                        cur_filter += f'arrayExists(i -> (i in ({multiple_filters})), {filter})'
                    else:
                        cur_filter += f'arrayExists(i -> (i = {multiple_filters}), {filter})'
                else:
                    cur_filter += f'arrayExists(i -> (i = {filters[filter]}), {filter})'
            else:
                if isinstance(filters[filter], list):
                    multiple_filters = ", ".join([f"\'{value.lower()}\'" for value in filters[filter]])
                    if len(filters[filter]) > 1:
                        cur_filter += f'{filter} in ({multiple_filters})'
                    else:
                        cur_filter += f'{filter} = {multiple_filters}'
                else:
                    cur_filter += f'{filter} = {filters[filter]}'
            filter_list.append(f'({cur_filter})')

    filter_string = '(' + ' and '.join(filter_list) + ')'
    return filter_string


class NeighborFinder:
    def __init__(self, client):
        self._client = client

    def get_search_neighbors(self, embedding, fields, k=5, filters=None, column='embedding', table='images',
                             return_scores=False):
        if filters is not None:
            filter_string = get_filter_string(filters.dict())
            table = '(select * from {table} where {filters})'.format(table=table, filters=filter_string)
        neighbors = self._client.query_df(neighbors_query.format(embedding=embedding,
                                                                 fields=fields,
                                                                 knn_k=k,
                                                                 column=column,
                                                                 table=table))

        neighbors = neighbors.drop_duplicates(subset=['filename'])
        if return_scores:
            return neighbors['filename'].apply(str).tolist(), neighbors['score'].tolist()
        if 'score' in neighbors:
            neighbors = neighbors.drop(columns=['score'])
        return neighbors.to_dict('records')

    def get_filtered_data(self, filters, n, fields, table):
        filter_string = get_filter_string(filters.dict())
        table = '(select * from {table} where {filters})'.format(table=table, filters=filter_string)
        samples = self._client.query_df(f'select {fields} from {table} limit {n}')
        return samples.to_dict('records')

    def get_sampled_images(self, n, fields, table):
        samples = self._client.query_df(f'select {fields} from {table}')
        if len(samples) >= n:
            samples = samples.sample(n)
        return samples.to_dict('records')

    def is_similar_image(self, embedding, alpha=0.05):
        return self._client.query('''SELECT 
        filename, cosineDistance({embedding}, embedding) as score
        FROM images
        Where score<{alpha}
        ORDER BY score ASC'''.format(embedding=embedding, alpha=alpha)).result_set

    def get_uploaded_neighbors(self, filename, k=5, filters=None, embedding_column='embedding',
                               target_column='embedding',
                               table='images'):
        if k == 0:
            return []
        emb_query = embedding_query.format(filename=filename, column=embedding_column)
        if filters is not None:
            filter_string = get_filter_string(filters.dict())
            table = '(select * from {table} where {filters})'.format(table=table, filters=filter_string)
        neighbors = self._client.query_df(neighbors_query.format(embedding=emb_query,
                                                                 knn_k=k,
                                                                 column=target_column,
                                                                 table=table,
                                                                 fields='filename, label, tags'))
        if len(neighbors) == 0:
            return []
        neighbors = neighbors.drop_duplicates(subset=['filename'])
        if 'score' in neighbors:
            neighbors = neighbors.drop(columns=['score'])
        return neighbors.to_dict('records')

    def get_tags(self, image_emb, k=5, sort='asc'):
        if k > 0:
            tags = self._client.query_df(tags_query.format(embedding=image_emb, knn_k=k, sort=sort))
            if 'tag' in tags:
                return tags['tag'].tolist()
        return []

    def update_fields(self, values, table, column_oriented=False):
        self._client.insert(table=table,
                            data=[values] if column_oriented is False else values,
                            column_oriented=column_oriented)
        self._client.query(f'OPTIMIZE TABLE {table}')

    def get_fields(self, filename, fields, table):
        fields = self._client.query_df(f'select {fields} from {table} where filename=\'{filename}\'')
        if len(fields) == 0:
            return None
        return fields.iloc[0].to_dict()

    def add_image(self, image: List[Any]):
        self._client.insert(table='images', data=[image])

    def delete_image(self, filename):
        for table in tables:
            self._client.query(f'DELETE FROM {table} WHERE filename=\'{filename}\'')
            self._client.query(f'OPTIMIZE TABLE {table}')
