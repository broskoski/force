import PropTypes from 'prop-types'
import React from 'react'
import block from 'bem-cn'

export const renderCheckboxInput = ({ input, ...custom }) => (
  <CheckboxInput
    {...custom}
    value={input.value}
    onChange={input.onChange}
  />
)

export default function CheckboxInput (props) {
  const { item, label, onChange, value } = props
  const b = block('consignments2-submission-checkbox-input')

  return (
    <div className={b('wrapper').mix('artsy-checkbox')} onClick={() => onChange(!value)}>
      <div className={b('input').mix('artsy-checkbox--checkbox')}>
        <input
          type='checkbox'
          name={item}
          value={item}
          checked={value || false}
          onChange={() => {}}
        />
        <label htmlFor={item} />
      </div>
      <label className={b('label')} htmlFor={item}>
        { label }
      </label>
    </div>
  )
}

CheckboxInput.propTypes = {
  item: PropTypes.string.isRequired,
  label: PropTypes.string,
  onChange: PropTypes.func.isRequired,
  value: PropTypes.bool
}
